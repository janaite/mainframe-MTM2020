//************************************************
//* CREATE AN EMPTY FEATURE DATASET
//************************************************
//NEWFT    PROC
//*
//STPRM    EXEC RMPROC,DSNME=&DSINFT.
//*
//STPG1    EXEC PGM=IEFBR14
//STEPLIB  DD DSN=&SYSUID..MTM20.LOAD,DISP=SHR
//OUTDATA  DD DSN=&DSINFT.,DISP=(NEW,CATLG,DELETE),
//         DCB=(DSORG=PS,RECFM=FB,LRECL=12,BLKSIZE=1200),
//         SPACE=(TRK,(85,10))
//*
//         PEND
