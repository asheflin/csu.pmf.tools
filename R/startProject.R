#' startProject
#'
#' @details take info from iLab and iLab sample submission form and create sample prep and data acquisition templates and directories on the R:  
#' @param prep.batch.size integer - what is the sample preparation batch size?  default = 48. 
#' @param run.batch.size integer - what is the analytical batch size? default = 96.
#' @param QC  integer - every 'QC' injections will be a QC sample.  Default = 6  
#' @param stack should the injection sample list be set up for stacked injections (TOF platforms only, currenly)
#' @param extraction.blanks integer - currently not used. (how many extraction blanks per prep batch?)
#' @param solvent.blanks  integer - currently not used.  (how many solvent blanks per run batch? )
#' @return returns a list of length 3: $design is the experimental sample factors after parsing by the delim, $data is the dataset, $full.data is merged $des and $data data.frames.
#' @concept RAMClustR
#' @author Corey Broeckling

#' @export 


startProject<-function (
  prep.batch.size = 48,
  run.batch.size=96,
  QC=6,
  randomize=TRUE,
  stack = FALSE,
  extraction.blanks = 3,
  solvent.blanks = 3
) {
  
  ## NEED TO ADD BATCH ORDER RANDOMIZATION
  ## CONSIDER THE BENEFITS OF ADDING RUN ORDER TO SAMPLE NAME VS REFERENCING BOTH SEQUENCE.CSV AND SEQ.CSV
  ## PLATFORM SPECIFIC COPYING OF R SCRIPTS TO R_SCRIPTS FOLDER
  
  require(tcltk)
  require(xlsxjars)
  require(xlsx)
  
  destination.dir = "R:/RSTOR-PMF/Projects/"
  
  redo = FALSE 
  
  while(!redo) {
    
    cat('\n', '\n', "please highlight all data in iLab project overview for your project", '\n',
        " - view all requests tab", '\n',
        " - expand project", '\n',
        " - expland 'overview", '\n',
        " - highlight all lines from 'core identifier' to 'labels'",'\n',
        " - right click  and copy or 'ctrl+c", '\n','\n')
    
    readline(prompt="Press [enter] to continue")
    
    suppressWarnings(d<-read.delim("clipboard", row.names = 1, header = FALSE, stringsAsFactors = FALSE))
    
    if(ncol(d) == 0) {
      d2 <- dimnames(d)[[1]]
      d3<-  rep(NA, length(d2))
      for (x in 1:length(d3))  {
        tmp<- unlist(strsplit(d2[x], ":"))
        dimnames(d)[[1]][x] <- paste(tmp[1], ": ", sep = "")
        d3[x] <- paste(tmp[2:length(tmp)], collapse = ":")
      }
      d <- data.frame(d, d3, stringsAsFactors = FALSE)
    }
    
    names(d)<-"value"
    cat('\n', '\n', "project name: ", d["Service id:",], '\n',
        "Lab: ", d["Lab Name:",],'\n',
        "PI: ", d["Lab PI(s):",], '\n', '\n', sep=""
    )
    
    feedback<- readline(prompt=cat(
      "please check the above data: ", '\n',
      " - to try again press [t]", '\n',
      " - to accept press [enter]", '\n', '\n'
    ))
    
    if(feedback != "t") {
      redo = TRUE 
    }
    
  }
  
  projdir<-paste0(destination.dir, d["Service id:",], "/")
  dir.create(projdir)
  
  write.csv(d, file = paste0(projdir, "ilab_overview.csv"), row.names = TRUE)
  
  #cat("Choose PI Directory (Lastname_Firstname)", '\n', '\n')
  #pidir<-choose.dir(default="K:/", caption = "Choose PI Directory (Lastname_Firstname)")
  cat("Choose Sample Submission Form", '\n', '\n')
  submissionform <- choose.files(caption = "please navigate to and select the sample submission excel file.")
  
  # returns string w/o leading whitespace
  trim.leading <- function (x)  sub("^\\s+", "", x)
  
  # returns string w/o trailing whitespace
  trim.trailing <- function (x) sub("\\s+$", "", x)
  
  # returns string w/o leading or trailing whitespace
  trim <- function (x) gsub("^\\s+|\\s+$", "", x)
  
  
  select.platforms <- function(){
    platforms<-c( 
      "GCMS_EI",      #1
      "TOF_PH_Pos",   #2
      "TOF_PH_Neg",   #3
      "TOF_T3_Pos",   #4
      "TOF_T3_Neg",   #5
      "TOF_Hil_Pos",  #6
      "TOF_Hil_Neg",  #7
      "TQS_PH",       #8
      "TQS_T3",       #9
      "TQS_Hil",      #10
      "Orbi",        #11
      "other1",      #12
      "other2",     #13
      "other3"      #14
    )
    
    
    ## ADD A LEVEL HERE FOR EACH PLATFORM ADDED ###########
    avar <- tclVar(0)
    bvar <- tclVar(0)
    cvar <- tclVar(0)
    dvar <- tclVar(0)
    evar <- tclVar(0)
    fvar <- tclVar(0)
    gvar <- tclVar(0)
    hvar <- tclVar(0)
    ivar <- tclVar(0)
    jvar <- tclVar(0)
    kvar <- tclVar(0)
    lvar <- tclVar(0)
    mvar <- tclVar(0)
    nvar <- tclVar(0)
    
    
    tt <- tktoplevel()
    tkwm.title(tt,"Platform Selection Window")
    
    ## ADD A LEVEL HERE FOR EACH PLATFORM ADDED ###########
    a.entry <- tkcheckbutton(tt, variable=avar)
    b.entry <- tkcheckbutton(tt, variable=bvar)
    c.entry <- tkcheckbutton(tt, variable=cvar)
    d.entry <- tkcheckbutton(tt, variable=dvar)
    e.entry <- tkcheckbutton(tt, variable=evar)
    f.entry <- tkcheckbutton(tt, variable=fvar)
    g.entry <- tkcheckbutton(tt, variable=gvar)
    h.entry <- tkcheckbutton(tt, variable=hvar)
    i.entry <- tkcheckbutton(tt, variable=ivar)
    j.entry <- tkcheckbutton(tt, variable=jvar)
    k.entry <- tkcheckbutton(tt, variable=kvar)
    l.entry <- tkcheckbutton(tt, variable=lvar)
    m.entry <- tkcheckbutton(tt, variable=mvar)
    n.entry <- tkcheckbutton(tt, variable=nvar)
    
    reset <- function()
    {
      ## ADD A LEVEL HERE FOR EACH PLATFORM ADDED ###########
      
      tclvalue(avar)<-0
      tclvalue(bvar)<-0
      tclvalue(cvar)<-0
      tclvalue(dvar)<-0
      tclvalue(evar)<-0
      tclvalue(fvar)<-0
      tclvalue(gvar)<-0
      tclvalue(hvar)<-0
      tclvalue(ivar)<-0
      tclvalue(jvar)<-0
      tclvalue(kvar)<-0
      tclvalue(lvar)<-0
      tclvalue(mvar)<-0
      tclvalue(nvar)<-0
    }
    
    submit <- function() {
      ## ADD A LEVEL HERE FOR EACH PLATFORM ADDED ###########
      a <- as.logical(as.numeric(tclvalue(avar)))
      b <- as.logical(as.numeric(tclvalue(bvar)))
      c <- as.logical(as.numeric(tclvalue(cvar)))
      d <- as.logical(as.numeric(tclvalue(dvar)))
      e <- as.logical(as.numeric(tclvalue(evar)))
      f <- as.logical(as.numeric(tclvalue(fvar)))
      g <- as.logical(as.numeric(tclvalue(gvar)))
      h <- as.logical(as.numeric(tclvalue(hvar)))
      i <- as.logical(as.numeric(tclvalue(ivar)))
      j <- as.logical(as.numeric(tclvalue(jvar)))
      k <- as.logical(as.numeric(tclvalue(kvar)))
      l <- as.logical(as.numeric(tclvalue(lvar)))
      m <- as.logical(as.numeric(tclvalue(mvar)))
      n <- as.logical(as.numeric(tclvalue(nvar)))
      
      en <- parent.env(environment())
      
      ## ADD A LEVEL HERE FOR EACH PLATFORM ADDED ###########
      en$a <- a
      en$b <- b
      en$c <- c
      en$d <- d
      en$e <- e
      en$f <- f
      en$g <- g
      en$h <- h
      en$i <- i
      en$j <- j
      en$k <- k
      en$l <- l
      en$m <- m
      en$n <- n
      
      
      tkdestroy(tt)
    }
    
    reset.but <- tkbutton(tt, text="Reset", command=reset)
    submit.but <- tkbutton(tt, text="submit", command=submit)
    
    tkgrid(tklabel(tt,text="Select Platforms"),columnspan=2)
    
    ## ADD A LEVEL HERE FOR EACH PLATFORM ADDED ###########
    tkgrid(tklabel(tt, text=platforms[1]), a.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[2]), b.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[3]), c.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[4]), d.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[5]), e.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[6]), f.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[7]), g.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[8]), h.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[9]), i.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[10]), j.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[11]), k.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[12]), l.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[13]), m.entry, pady = 10, padx =10)
    tkgrid(tklabel(tt, text=platforms[14]), n.entry, pady = 10, padx =10)
    
    
    tkgrid(submit.but, reset.but)
    
    tkwait.window(tt)
    
    ## ADD A LEVEL HERE FOR EACH PLATFORM ADDED ###########
    return(data.frame(platforms, 'select'=c(a,b,c,d,e,f,g,h,i,j,k,l,m,n), stringsAsFactors=FALSE))
  }
  platforms <- select.platforms()
  
  paramsets<-list(
    TOF_Hil_Pos=data.frame(c(chrominst="Waters UPLC: Sequant ZIC-pHILIC",
                             msinst="Waters Xevo G2 TOF",
                             column="Sequant ZIC-pHilic, 2 x 150 mm, 5 uM",
                             solvA="Water, 10 mM Ammomium Bicarbonate, pH 9.6",
                             solvB="Acetonitrile",
                             MSlevs=2,
                             CE1="6",
                             CE2="15-30",
                             mstype="TOF",
                             mzdifftof=0.05,
                             msmode="P",
                             ionization="ESI",
                             ESIvoltage="2200",
                             colgas="Ar",
                             msscanrange="50-1200",
                             conevolt="30")),
    
    TOF_Hil_Neg=data.frame(c(chrominst="Waters UPLC: Sequant ZIC-pHILIC",
                             msinst="Waters Xevo G2 TOF",
                             column="Sequant ZIC-pHilic, 2 x 150 mm, 5 uM",
                             solvA="Water, 10 mM Ammomium Bicarbonate, pH 9.6",
                             solvB="Acetonitrile",
                             MSlevs=2,
                             CE1="6",
                             CE2="15-30",
                             mstype="TOF",
                             mzdifftof=0.05,
                             msmode="N",
                             ionization="ESI",
                             ESIvoltage="2200",
                             colgas="Ar",
                             msscanrange="50-1200",
                             conevolt="30")),
    
    TOF_T3_Pos=data.frame(c(chrominst="Waters UPLC: C18 ACN Gradient",
                            msinst="Waters Xevo G2 QTOF",
                            column="Waters HSST3 C18, 1 x 100 mm, 1.8 uM",
                            solvA="Water, 0.1% formic acid",
                            solvB="ACN, 0.1% formic acid",
                            MSlevs=2,
                            CE1="6",
                            CE2="15-30",
                            mstype="TOF",
                            mzdifftof=0.05,
                            msmode="P",
                            ionization="ESI",
                            ESIvoltage="2200",
                            colgas="Ar",
                            msscanrange="50-1200",
                            conevolt="30")) ,
    
    TOF_T3_Neg=data.frame(c(chrominst="Waters UPLC: C18 ACN Gradient",
                            msinst="Waters Xevo G2 QTOF",
                            column="Waters HSST3 C18, 1 x 100 mm, 1.8 uM",
                            solvA="Water, 0.1% formic acid",
                            solvB="ACN, 0.1% formic acid",
                            MSlevs=2,
                            CE1="6",
                            CE2="15-30",
                            mstype="TOF",
                            mzdifftof=0.05,
                            msmode="N",
                            ionization="ESI",
                            ESIvoltage="2200",
                            colgas="Ar",
                            msscanrange="50-1200",
                            conevolt="30")) ,
    
    TOF_PH_Pos=data.frame(c(chrominst="Waters UPLC: ACN Gradient",
                            msinst="Waters Xevo G2 QTOF",
                            column="Waters CSH PhenylHexyl, 1 x 100 mm, 1.7 uM",
                            solvA="Water, 0.1% formic acid, 2mM AmOH",
                            solvB="ACN, 0.1% formic acid",
                            MSlevs=2,
                            CE1="6",
                            CE2="15-30",
                            mstype="TOF",
                            mzdifftof=0.05,
                            msmode="P",
                            ionization="ESI",
                            ESIvoltage="2200",
                            colgas="Ar",
                            msscanrange="50-2000",
                            conevolt="30")) ,
    
    TOF_PH_Neg=data.frame(c(chrominst="Waters UPLC: ACN Gradient",
                            msinst="Waters Xevo G2 QTOF",
                            column="Waters CSH PhenylHexyl, 1 x 100 mm, 1.7 uM",
                            solvA="Water, 0.1% formic acid, 2mM AmOH",
                            solvB="ACN, 0.1% formic acid",
                            MSlevs=2,
                            CE1="6",
                            CE2="15-30",
                            mstype="TOF",
                            mzdifftof=0.05,
                            msmode="N",
                            ionization="ESI",
                            ESIvoltage="2200",
                            colgas="Ar",
                            msscanrange="50-2000",
                            conevolt="30")) ,
    
    GCMS_EI=data.frame(c(chrominst="Thermo Trace GC: TG-5MS column",
                         msinst="Thermo ISQ",
                         MSlevs=1,
                         InletTemp="280",
                         TransferTemp="280",
                         mstype="QUAD",
                         mzdiffquad=0.5,
                         msmode="P",
                         ionization="EI",
                         msscanrange="50-650",
                         scantime="0.2",
                         energy="70",
                         deriv="Methoxyamine+MSTFA")) ,
    
    Orbi=data.frame(c(chrominst="Waters UPLC: C8 MeOH Gradient",
                      msinst="Waters Xevo G2 TOF",
                      column="Waters C8, 1 x 100 mm, 1.7 uM",
                      solvA="97% water, 1% ACN, 0.1% formic acid",
                      solvB="ACN, 0.1% formic acid",
                      MSlevs=1,
                      CE1="",
                      CE2="",
                      mstype="Orbitrap Velos Pro",
                      mzdifftof=0.05,
                      msmode="P",
                      ionization="NSI",
                      ESIvoltage="",
                      colgas="N",
                      msscanrange="100-2000",
                      conevolt="")),
    
    TQS_Hil=data.frame(c(chrominst="Waters UPLC: Sequant ZIC-pHilic",
                         msinst="Waters TQS",
                         column="Sequant ZIC-pHilic, 2 x 150 mm, 5 uM",
                         solvA="Water, 10mM AmBicarb pH 9.6",
                         solvB="ACN",
                         MSlevs=1,
                         CE1="6",
                         CE2="",
                         mstype="QQQ",
                         msmode="P",
                         ionization="ESI",
                         ESIvoltage="2200",
                         colgas="Ar",
                         msscanrange="50-1200",
                         conevolt="30")),
    
    TQS_PH=data.frame(c(chrominst="Waters UPLC: ACN Gradient",
                        msinst="Waters TQS",
                        column="Waters CSH PhenylHexyl, 1 x 100 mm, 1.7 uM",
                        solvA="Water, 0.1% formic acid, 2mM AmOH",
                        solvB="ACN, 0.1% formic acid",
                        MSlevs=1,
                        CE1="6",
                        CE2="",
                        mstype="QQQ",
                        msmode="P",
                        ionization="ESI",
                        ESIvoltage="2200",
                        colgas="Ar",
                        msscanrange="50-2000",
                        conevolt="30")) ,
    
    TQS_T3=data.frame(c(chrominst="Waters UPLC: ACN Gradient",
                        msinst="Waters TQS",
                        column="Waters T3 C18, 1 x 100 mm, 1.8 uM",
                        solvA="Water, 0.1% formic acid",
                        solvB="ACN, 0.1% formic acid",
                        MSlevs=1,
                        CE1="6",
                        CE2="",
                        mstype="QQQ",
                        msmode="P",
                        ionization="ESI",
                        ESIvoltage="2200",
                        colgas="Ar",
                        msscanrange="50-1200",
                        conevolt="30")) ,
    
    ICP=data.frame(c(chrominst="none",
                     msinst="PerkinElmer Elan DRC ICP-MS",
                     column="none",
                     solvA="none",
                     solvB="none",
                     MSlevs=1,
                     CE1="none",
                     CE2="none",
                     mstype="Quad",
                     mzdifftof="none",
                     msmode="P",
                     ionization="ICP",
                     ESIvoltage="",
                     colgas="Ar",
                     msscanrange="",
                     conevolt="")),
    
    newLC=data.frame(c(chrominst="Waters UPLC",
                       msinst="",
                       column="",
                       MSlevs=2,
                       solvA="",
                       solvB="",
                       CE1="6",
                       CE2="",
                       mstype="",
                       msmode="P",
                       ionization="ESI",
                       colgas="Ar",
                       msscanrange="50-1200",
                       conevolt="30")),
    
    newGC=data.frame(c(chrominst="Thermo Trace GC: TG-5MS column",
                       msinst="Thermo ISQ",
                       MSlevs=1,
                       InletTemp="280",
                       TransferTemp="280",
                       mstype="QUAD",
                       mzdiffquad=0.5,
                       msmode="P",
                       ionization="EI",
                       msscanrange="50-650",
                       scantime="0.2",
                       energy="70",
                       deriv="Methoxyamine+MSTFA"))
  )
  
  
  ExpVars<-c(Experiment=d["Service id:",1],
             PI=d["Lab Name:",1],
             User="",
             Species="",
             Sample="",
             platform="",
             delim="-",
             fact1name="",
             fact2name="",
             fact3name="",
             fact4name="",
             fact5name="",
             fact6name="",
             fact7name="",
             fact8name="",
             fact9name="",
             fact10name=""
  )
  
  VarDesc<-c("experiment name, no spaces",
             "Name of Principle Investigator",
             "Name of User (person submitting samples)",
             "species name (binomial latin name)",
             "sample type",
             paste(names(paramsets), sep=" ", collapse=" "),
             "factor delimitor in your sample names",
             "Assign a name for your factors",
             "",           
             "",           
             "",           
             "",           
             "",
             "",
             "",
             "",
             ""
  )
  
  fnrange<-grep("fact1name", names(ExpVars))
  
  rename<-intersect(grep("other", platforms[,1]), which(platforms[,2]))
  if(length(rename) >0 )  {
    for(i in rename) {
      cat ("PLEASE ENTER NEW NAME and press 'ENTER'", as.character(platforms[i,1]), ":", '\n')
      platforms[i,1] <- readline()
    }
  }
  
  answer <- "t"
  while(answer == "t") {
    smp<-read.xlsx(submissionform, sheetName = "SampleList", startRow=4, header=TRUE, stringsAsFactors=FALSE)
    #cat(" Reading and checking sample submission form: ", '\n', '\n')
    cat ("PLEASE CHECK TO ENSURE FACTOR NAMES ARE ALL CORRECT: ", "\n", '\n')
    
    narow<-function(x) {return(!all(is.na(smp[x,])))}
    narows<-sapply(1:nrow(smp), FUN=narow)
    smp<-smp[narows,]
    nacol<-function(x) {return(!all(is.na(smp[,x])))}
    nacols<-sapply(1:ncol(smp), FUN=nacol)
    smp<-smp[,nacols]
    
    for (i in 1:ncol(smp)) {
      cat(names(smp)[i], '\n')
      cat("  levels:", unique(smp[,i]), '\n', '\n')
    }
    
    cat ("TYPE [enter] IF CORRECT AND 't' to try again", '\n', sep="")
    answer <- readline()
    
    if(answer == 't') {
      cat('\n', '\n', "PLEASE CORRECT SAMPLE NAMES IN SAMPLE SUBMISSION FORM AND SAVE", '\n',
          "when complete, press [enter] to continue and try again", '\n', '\n', sep="")
      readline()
    } else {
      answer == "go"
    }
    
  }
  
  ## remove any leading or trailing spaces, and ensure interal spaces and dashes are replaced with underscores
  for(i in 1:ncol(smp)) {
    smp[,i] <- gsub("-", "_", smp[,i])
    smp[,i] <- gsub(" ", "_", smp[,i])
    smp[,i] <- trim(smp[,i])
  }
  
  names(smp) <- gsub("-", "_", names(smp))
  names(smp) <- gsub(" ", "_", names(smp))
  names(smp) <- trim(names(smp))
  
  ## assign random prep order, and batch blank column
  smp <- data.frame(
    "pmf.sn" = 1:nrow(smp),
    "prep_order" = sample(1:nrow(smp), replace = FALSE),
    "prep_batch" = rep(NA, nrow(smp)),
    smp, stringsAsFactors = FALSE
    )
  
  ## reorder and write out csv file. 
  smp <- smp[order(smp$prep_order),]
  smp[,"prep_batch"] <- 1 + floor((smp$prep_order-1)/prep.batch.size)
  write.csv(smp, file = "prep.sample.list.csv", row.names = FALSE)
  
  qcline <- smp[1,]
  qcline[1,1:ncol(qcline)] <- "QC"
  
  ## randomize run order for samples, then
  ## add qc line as first row, + qc rows at desired spacing and last row. 
  run.order <- sample(1:nrow(smp), replace = FALSE)
  smp <- smp[sample(1:nrow(smp), replace = FALSE),]
  
  smp <- rbind(qcline, smp)
  current.row <- 1
  while(current.row < nrow(smp)) {
    is.qc <- grep("QC", smp[,"prep_order"])
    if(length(is.qc)==0) {is.qc <- 0}
    max.qc <- max(is.qc)
    next.qc <- max.qc + QC
    if(next.qc > nrow(smp)) {break}
    smp <- rbind(smp[1:(next.qc - 1),], qcline, smp[next.qc:nrow(smp),])
    current.row <- next.qc
  }
  smp <- rbind(smp, qcline)
  
  must.qc <- sort(c(seq(from = 0, to = (3*nrow(smp)),  run.batch.size), seq(from = 1, to = (3*nrow(smp)),  run.batch.size)))
  must.qc <- must.qc[which(must.qc > 0)]
  
  for(i in must.qc) {
    if(i > nrow(smp)) break
    if(!smp[i, "prep_order"] == "QC") {
      smp <- rbind(smp[1:(i - 1),], qcline, smp[i:nrow(smp),])
    }
  }
  batch <- vector()
  for(i in 1:(ceiling(nrow(smp)/run.batch.size))) {
    batch <- c(batch, rep(i, run.batch.size))
  }
  batch <- batch[1:nrow(smp)]
  smp <- data.frame(smp[,1:3], "run_order" = 1:nrow(smp), "run_batch" = batch, smp[,4:ncol(smp)], stringsAsFactors = FALSE)
  smp <- data.frame(smp, "sample.name" = sapply(1:nrow(smp), FUN = function(x) {paste(smp[x,], collapse = "-")} ), stringsAsFactors = FALSE)
  # write.csv(smp, file = "run.sample.list.csv", row.names = FALSE)
  
  projname<-d["Service id:",1]

  fnrange<-fnrange:(fnrange+length(names(smp))-1) 
  ExpVars[fnrange]<-names(smp)
  
  # design<-suppressWarnings(edit(Experiment))
  # 
  # platform<-platforms[grep(as.character(design["platform",1]), platforms, ignore.case=TRUE)]
  # 
  # instrument<-edit(paramsets[[as.character(platform)]])
  # 
  # exp.pars<-list(design, instrument)
  # names(exp.pars)<-c("design", "instrument")
  
  
  # cat("project directory created", paste0(pidir, "/", projname), '\n')
  file.copy(from=submissionform, to=paste0(projdir, projname, ".", tools::file_ext(submissionform)))
  #samples<-data.frame(orig_order, pmfname, smp)
  #write.csv(samples, file=paste0(projdir, projname, "_samples.csv"), row.names=FALSE)
  # bsize<-batchsize-floor(batchsize/QC)-1
  # bnum<-ceiling(nrow(smp)/bsize)
  # randsamples<-data.frame("batch"=rep(NA, nrow(samples)), "order"=rep(NA, nrow(samples)), samples)
  # qcline<-randsamples[1,]; qcline[,"pmfname"]<-"QC"; qcline[,1:ncol(qcline)]<-NA
  doplatforms<-which(platforms[,2])
  for(i in doplatforms) {
    setwd(projdir)
    Exp<-ExpVars
    Exp["platform"]<-as.character(platforms[i,"platforms"])
    Experiment<-data.frame(Exp,stringsAsFactors=FALSE)
    cat("  Please edit instrument parameters as approriate: ", Exp["platform"], '\n')
    if(!is.null(paramsets[[as.character(Exp["platform"])]])) {
      instrument<-edit(paramsets[[as.character(Exp["platform"])]])
    } else {
      cat ("PLATFORM", as.character(platforms[i,"platforms"]) , ": TYPE 'g' FOR NEW GC-MS PLATFORM AND 'l' FOR NEW LC-MS PLATFORM", '\n')
      answer <- readline()
      if(grepl('g', answer)) {
        instrument<-edit(paramsets[['newGC']])
      } else {
        instrument<-edit(paramsets[['newLC']])
      }
    }
    ExpDes<-list(Experiment, instrument)
    names(ExpDes)<-c("design", "instrument")
    dir.create(platforms[i,1])
    setwd(platforms[i,1])
    save(ExpDes, file="ExpDes.Rdata")
    dir.create("R_scripts")
    # file.copy(from = "K:/pmfWorkflow/run_pmfWorkflow.R", to = paste0("R_scripts/run_pmfWorkflow.R"))
    # file.copy(from = "K:/pmfWorkflow/pmfWorkflowFunctions.R", to = paste0("R_scripts/pmfWorkflowFunctions.R"))
    
    tmp <- smp
    tmp <- data.frame(tmp, 
                      "filename" = paste(projname, formatC(1:nrow(tmp), width = nchar(nrow(tmp)), flag = 0), sep = "-"), 
                      stringsAsFactors = FALSE)
    reord <- sample(which(tmp[,1] != "QC"), replace = FALSE)
    tmp[which(tmp[,1] != "QC"),] <- tmp[reord,]
    
    if(stack & grepl("TOF_", Exp["platform"])) {
      
      tmpstack<-tmp
      tmpstack$filename<-paste(tmpstack$filename, "_stack", sep="")
      tmpinj<-tmp
      tmp<-tmp[0,]
      for(k in 1:nrow(tmpstack)) {
        tmp<-rbind(tmp, tmpstack[k,], tmpinj[k,])
      }
    }
    
    write.csv(tmp, file="sequence.csv", row.names=FALSE)
    setwd(projdir)
  }
  setwd(projdir)
  cat("FINISHED: created directories for the following platforms", platforms[doplatforms, 1], '\n')
}

# startProject
