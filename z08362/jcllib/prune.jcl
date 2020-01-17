//*********************************************************************
//* PRUNE
//* ALL OCCURENCES BELOW A THRESHOLD WILL BE REMOVED
//*********************************************************************
//PRUNE    PROC
//*
//STEP01   EXEC RMPROC,DSNME=&PRFDSFQ2..G&GEN.
//*
//STEP02   EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=&PRFDSFQ1..G&GEN.,DISP=SHR
//SORTOUT  DD DSN=&PRFDSFQ2..G&GEN.,DISP=(NEW,CATLG,DELETE),
//            SPACE=(21,(20,10)),AVGREC=U,
//            DCB=(DSORG=PS,RECFM=F,LRECL=21)
//SYMNAMES DD *,SYMBOLS=EXECSYS
   MINFREQ,&MINSUP.
/*
//SYSIN    DD *
   SORT FIELDS=COPY
   INCLUDE COND=(13,9,FS,GE,MINFREQ)
/*
//*
//         PEND
