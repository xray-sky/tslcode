#! /bin/sh
#---------
# second system effect - third system clearly called for. but later, maybe.
#
# AIX PS/2 with 6157 QIC will stop on a tape read error, but will write the block in 
# error to disk before aborting the read! (may be unique per attempt)
#
# DO NOT TRUST THE LAST BLOCK OF A PARTIAL TAPE FILE ON AIX PS/2!
#
# SCSI tape drives discard error blocks; QIC-02 and other interfaces appear to
# return the error block as-read.
#
# All blocks written on SunOS with SCSI tape drives may be used for recovery purposes.
#

PATH=/bin:/usr/bin:/usr/sbin:/usr/ucb:/usr/5bin
OS=`uname -sr`
RETENSION="FALSE"
MAP="FALSE"
SWAP="FALSE"
NODATA="FALSE"
BLOCKSIZE="512"
OPTIONS=""
FILE="0"
PART="1"


get_tape_status() {

        case $OS in
	"SunOS 4.0")
		if [ "x$PAUSE" = "xTRUE" ] ; then
			sleep 5
		fi
		# mt status exists but seems broken on 386i with MT-02

		case $rc in
		0)
			if [ `wc -c file.$OFILE | awk '{ print $1 }'` -eq 0 ] ; then
				EOM=1
			else
				PART="1"
				FILE=`expr $FILE + 1`
			fi
			;;
		5)
			OPEND=`date '+%H%M%S'`
			ELAPSED=`expr $OPEND - $OPSTART`
			if [ $ELAPSED -ge 0 -a $ELAPSED -lt 5 ] ; then
				rc="5 (err_EOM)"
				EOM=1
			fi
			echo "$FILE rc=$rc" >> $RPT
                        PART=`expr $PART + 1`
			OPSTART=$OPEND
			;;
		*)
			echo "$FILE rc=$rc / abort" >> $RPT
			echo "abort."
			EOM=1
			;;
		esac
		;;
        "SunOS "*)
                if [ "x$PAUSE" = "xTRUE" ] ; then
                        sleep 5
                fi

                eval `mt -f $TAPE status | tail -2 | sed -e 's/   /";/g
                                                             s/^";//
                                                             s/= /="/g
                                                             s/$/"/
                                                             s/(/="/
                                                             s/)="/ /
                                                             s/ /_/g'`

                FILE="$file_no"

                if [ "$sense_key" = "0x13_EOT" ] ; then EOM=1 ; fi
                if [ "$sense key" = "0x8_Blank_Check" ] ; then
                        echo "blank check."
                        EOM=1
                fi
                if [ "$sense_key" = "0x12_EOF" ] ; then
                        PART="1"
                fi
                if [ "$block_no" != "0" ] ; then
                        PART=`expr $PART + 1`
                fi
                if [ "$RC" != "0" ] ; then
                        echo "$file_no $block_no $sense_key $residual" >> $RPT
                        if [ "x$HALT" = "xTRUE" ] ; then
                                echo "Halt on error requested." >> $RPT
                                exit 1
                        fi
                fi
                ;; # $sense_key $residual $retries $file_no $block_no
		"AIX 3.0") # AIX PS/2 1.3

			case $rc in
			"0")
				PART="1"
				FILE=`expr $FILE + 1`
				;;
			"2")
				if [ `wc -c $OFILE` -eq 0 ] ; then
					EOM=1
				else
					echo "$FILE rc=$rc" >> $RPT
					PART=`expr $PART + 1`
					echo -n "Repositioning..."
					POS=`ls ./file* | wc -l`
					while [ $POS -gt 0 ] ; do
						echo -n " ${POS}..."
						mt fsf
						if [ $? -ne 0 ] ; then 
							echo "transport error?"
							exit 127
						fi
						POS=`expr $POS - 1`
					done
					echo " continue."
				fi
				;;
			"13")
				echo "$FILE rc=$rc" >> $RPT
				echo "truncated write. ulimit=`ulimit -f`" | tee -a $RPT
				exit 13
				;;
			*)
				echo "$FILE rc=$rc / abort" >> $RPT
				echo "abort."
				EOM=1
				;;
			esac
			;;
        *)
                echo "Unimplemented platform"
                exit 255
                ;;
        esac
        
}
#
# parse options
# will use $TAPE if not explicitly set
#

args="$@"

set -- $args 
until [ -z "$1" ] ; do 
        case $1 in
		"-map")
				case $OS in
				"SunOS 5"*)
					MAP="TRUE"
					;;
				*)
					echo "blocksize mapping not supported on platform $OS"
					;;
				esac
				;;
		"-maponly")
				case $OS in
				"SunOS 5"*)
					MAP="TRUE"
					NODATA="TRUE"
					;;
				*)
					echo "blocksize mapping not supported on platform $OS"
					;;
				esac
				;;
        "-dev")
                shift
                TAPENUM="$1" 
                ;;
        "-ret")
                RETENSION="TRUE" 
                ;;
        "-swap")
                SWAP="TRUE" 
                ;;
        "-skip")
                shift
                SKIP="$1"
                ;;
        "-bs")
                shift
                BLOCKSIZE="$1"
                ;;
        "-opts")
                shift
                OPTIONS="$OPTIONS $1"
                ;;
        "-pause")
                PAUSE="TRUE"
                ;;
        "-halt")
                HALT="TRUE"
                ;;
        "-labels")
                shift
                if [ "$1" = "ibm" -o "$1" = "ansi" ] ; then 
                        LABELS="$1"
                else
                        echo "Unsupported label style $1"
                fi
                ;;
        *)
                TAPENUM="$1"
                ;;
        esac
shift
done

case $OS in
"SunOS 4.0")
	DATESTR='+20%y%m%d.%T'
	TAPE=${TAPE:=/dev/$TAPENUM}
	OPSTART=`date '+%H%M%S'`
	;;	
"SunOS 4"*)
	DATESTR='-u +20%y%m%d.%T'
	TAPE=${TAPE:=/dev/$TAPENUM}
	;;	
"SunOS 5"*)
	DATESTR='-u +%Y%m%d.%T'
	TAPE=${TAPE:=/dev/rmt/$TAPENUM}
	;;
"AIX 3.0")
	ulimit -f 4194303	# effectively unlimited ; default=8192
	DATESTR='-u +19%y%m%d.%T'
	TAPE=${TAPE:=/dev/$TAPENUM}
	;;
*)
        echo "Unimplemented platform"
        exit 255
        ;;
esac

if [ ! -b "$TAPE" -a ! -c "$TAPE" ] ; then
        echo "invalid tape device ($TAPE)."
        exit 1
fi

if [ -f "./byte-swap" -o "$SWAP" = "TRUE" ] ; then 
        OPTIONS="conv=swab $OPTIONS" 
fi

if [ -f "./labels.ibm" ] ; then
        LABELS="ibm"
fi

if [ -f "./labels.ansi" ] ; then
        LABELS="ansi"
fi

if [ "$RETENSION" = "TRUE" ] ; then 
	echo "Retensioning $TAPE"
	mt -f $TAPE retension
	if [ $? -ne 0 ] ; then
		echo "Transport error during retension" 
		exit 255
	fi
fi

RPT="report.`date $DATESTR`"
echo "($OS) `mt -f $TAPE status | head -1`" > $RPT

while [ -z "$EOM" ] ; do

	if [ "$PART" = "1" ] ; then
		OFILE="`date $DATESTR`.$FILE"
	else
		OFILE="`date $DATESTR`.$FILE-$PART"
	fi

        if [ "x$LABELS" != "x" -a `expr $FILE % 3` -ne 1 ] ; then
                OBS=$BLOCKSIZE
                BLOCKSIZE=80
        fi

		if [ "$MAP" = "FALSE" ] ; then
				dd if=$TAPE of=file.$OFILE bs=$BLOCKSIZE $OPTIONS
				rc=$?
        else
				if [ "$NODATA" = "FALSE" ] ; then
						truss -t read -o blocks.$OFILE dd if=$TAPE of=file.$OFILE bs=$BLOCKSIZE $OPTIONS
				else
						if [ "$PART" = "1" ] ; then
								OFILE=`ls file*.$FILE | sed -e 's/^file\.//'`
						else 
								OFILE=`ls file*.$FILE-$PART | sed -e 's/^file\.//'`
						fi
						truss -t read -o blocks.$OFILE dd if=$TAPE of=/dev/null bs=$BLOCKSIZE $OPTIONS
				fi
		fi
		
        RC="$?"

        if [ "x$LABELS" != "x" -a `expr $FILE % 3` -ne 1 ] ; then
                BLOCKSIZE=$OBS
                if [ "$LABELS" = "ibm" ] ; then
                        dd if=file.$OFILE cbs=80 conv=asciib >> labels.ibm
                        echo >> labels.ibm
                else
                        dd if=file.$OFILE cbs=80 >> labels.ansi
                        echo >> labels.ansi
                fi
        fi

        get_tape_status

done
