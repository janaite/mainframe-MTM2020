//************************************************
//* PREPARE FIRST GENERATION OF COMBINATIONS
//* IN THIS CASE IS A MASK WITH ONLY ONE BIT
//* IN EACH FEATURE AT TIME
//************************************************
//PREPG00  PROC
//*
//STEP01   EXEC RMPROC,DSNME=&PRFDSCMB..G00
//*
//STEP02   EXEC PGM=GEN1
//STEPLIB  DD DSN=&SYSUID..MTM20.LOAD,DISP=SHR
//OUTDATA  DD DSN=&PRFDSCMB..G00,
//         DISP=(NEW,CATLG,DELETE),
//         DCB=(DSORG=PS,RECFM=FB,LRECL=12),
//         SPACE=(12,(20,10)),AVGREC=U
//         PEND
