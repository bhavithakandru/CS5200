# Created a global variable that is storing the value "docDB"
rootDir <- "docDB"

# Created a function configDB which is used to create a new file or directory
configDB <- function(root,path=" "){
  if(path==""&&(!file.exists(root))){
    dir.create(root)
  }
  else if (!file.exists(path)){
    dir.create(path)
  }
}

# Created a function to get the extension of a file
getExtension <- function(fileName){
  ext <- toupper(tools::file_ext(fileName))
  return(ifelse(ext == "JPEG", "JPG", ext))
}

# Created a function to get the stem of the file
getFileStem <- function(fileName) {
  stem <- tools::file_path_sans_ext(fileName)
  return(stem)
}

# Created a function called genObjpath which is used for generating the object path
genObjPath <- function(root, tag) {
  tag <- toupper(tag)
  if (tag == "JPEG") {
    tag <- "JPG"
  } else if (tag %in% c("DOC", "DOCX")) {
    tag <- "DOC"
  }
  return(file.path(root, tag))
}

# Created a function called storeObjs which reads data from one file and specifies in a folder argument
storeObjs <- function(folder, root, verbose){
  files <- list.files(path=folder)
  if(length(files)!=0)
  {
    for(i in 1:length(files))
    {
      n=getFilename(files[i])
      x=getTags(files[i])
      go=paste0("Copying ",n," to ")
      
      for(j in 1:length(x))
      {
        tag=strippedTag(x[j])
        objpath=genObjpath(root,x[j])
        configDB(root,objpath)
        y=paste0(folder,"/",files[i])
        file.copy(y,objpath)
        file.rename(paste0(objpath,"/",files[i]),paste0(objpath,"/",n))
        go=paste0(go,tag,",")
      }
      if(verbose==TRUE)
      {
        message <- sprintf("Copying %s to folder %s", stem, destFolder)
        print(message)
      }
    }
  }  
  else
  {
    print("No files and directories exixts in the folder")
  }
  
}

# Created a function which deletes all files present in the root file but not the root
clearDB <- function(root){
  allfiles=paste0(root,"/*")
  unlink(allfiles,recursive = TRUE)
}

#created main funtion in which we call all the functions created.

## Test Case
main <- function(){
  configDB(rootDir, "")
  print(getExtension("CampusAtNight.png"))
  print(getFileStem("CampusAtNight.jpg"))
  print(genObjPath(rootDir, "jpg"))
  storeObjs("test_folder", rootDir, TRUE)
  clearDB(rootDir)
}

# Calling main function
main()

#Calling Quit function
quit()
