//************************************************
//* PREPARE DATA.FTRRDS
//* (RE)CREATE AND IMPORT DATA FROM INPUT.FEATURES
//*
//* INPUT: DSINFT, DSFT
//************************************************
//PREPFT    PROC
//*
//*********************************************************************
//* (RE)CREATE RDDS FEATURE DATA SET
//*********************************************************************
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD   SYSOUT=*
//SYSIN    DD   *,SYMBOLS=EXECSYS
  DELETE   &DSFT.
  SET      MAXCC = 0
  DEFINE   CLUSTER  (NAME(&DSFT.)  -
                    VOLUMES(VPWRKE)  -
                    TRACKS(2,1)      -
                    RECORDSIZE(12 12)  -
                    REUSE -
                    FREESPACE(3 3)   -
                    NUMBERED)        -
           DATA     (NAME(&DSFT..DATA))
/*
//*********************************************************************
//* IMPORT DATA
//*********************************************************************
//STEP2    EXEC PGM=IDCAMS
//SYSPRINT DD   SYSOUT=*
//SYSOUT   DD   SYSOUT=*
//DD1      DD   DSNAME=&DSINFT.,DISP=SHR
//DD2      DD   DSNAME=&DSFT.,DISP=OLD
//SYSIN    DD   *
  REPRO -
      INFILE(DD1) -
      OUTFILE(DD2)
/*
//*
//         PEND
