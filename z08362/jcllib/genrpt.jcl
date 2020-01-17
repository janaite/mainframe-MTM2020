//*********************************************************************
//* GENERATE THE REPORT OF OPERATION
//*
//* INPUT: PRFDSFQ2
//*********************************************************************
//*
//GENRPT   PROC
//*
//*
//STEP01   EXEC RMPROC,DSNME=&SYSUID..MTM20.OUTPUT.REPORT
//*
//STEP02   EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=&PRFDSFQ2..G00,DISP=SHR
//         DD DSN=&PRFDSFQ2..G01,DISP=SHR
//         DD DSN=&PRFDSFQ2..G02,DISP=SHR
//         DD DSN=&PRFDSFQ2..G03,DISP=SHR
//         DD DSN=&PRFDSFQ2..G04,DISP=SHR
//         DD DSN=&PRFDSFQ2..G05,DISP=SHR
//         DD DSN=&PRFDSFQ2..G06,DISP=SHR
//SORTOUT  DD DUMMY
//OUTPUT1  DD DSN=&SYSUID..MTM20.OUTPUT.REPORT,
//         DISP=(NEW,CATLG,DELETE),
//         SPACE=(CYL,(1,1),RLSE),
//         DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//SYSIN    DD *
   SORT FIELDS=(13,9,FS,D)
   INCLUDE COND=(13,9,FS,GE,2)
   OUTFIL FNAMES=OUTPUT1,LINES=15,REMOVECC,
     HEADER2=(/,8:'Apriori Occurences Estimation Report',/,X,/,
       30:'Page',PAGE,45:DATE=(MD4-),X,TIME=(24:),/,X,/,
       12:'FEATURES',30:'# OCCURRENCES',/,
       10:'------------',30:'-------------'),
     OUTREC=(10:1,12,32:13,9,80:X)
/*
//*********************************************************************
//         PEND
