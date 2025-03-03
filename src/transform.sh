#!/bin/bash

in_xml_path=/veld/input/xml/"$in_xml_file"
in_xsl_path=/veld/input/xsl/"$in_xsl_file"
out_txt_path=/veld/output/"$out_txt_file"

# function to call xsltproc. If the parameters are files, xsltproc is called directly on them. If 
# the parameters are folders, then this function goes through the content of the folder recursively
# and creating equivalent output folder / file structure for each matching xml file input.
do_xslt_recursively() {

  # quick info on current recursive level / parameters
  # echo "do_xslt_recursively" "$1" "$2" "$3"

  # if file
  if [ -f "$2" ]; then

    # if xml
    if [[ "$2" == *.xml ]]; then

      # since the current parameter is a xml file, call xsltproc on it
      # echo "is xml. processing"

      # create parent folder of output (if it doesn't exist)
      out_txt_path_folder=${3%/*}
      if ! [ -e "$out_txt_path_folder" ]; then
        mkdir -p "$out_txt_path_folder"
      fi

      # call xsltproc
      #echo "executing: xsltproc ${1} ${2} > ${3}"
      #xsltproc "$1" "$2" > "$3"
      command="xsltproc"
      if [ "$set_verbose" = "true" ] ; then
        command+=" --verbose"
      fi
      command+=" ${1} ${2} > ${3}"
      echo "executing:"
      echo "$command"
      eval "$command"

    else

      # if the input parameter is a non-xml file, this must have been a mistake. Abort then.
      # echo "not a xml file" "$2"
      exit 1
    fi

  # if folder
  elif [ -d "$2" ]; then
    # echo "check content of folder" "$2"

    # iterate over content of folder
    for file_or_folder in "$2"/*; do
      # echo "check if file or folder" "$file_or_folder"

      # if file
      if [ -f "$file_or_folder" ]; then

        # if xml
        if [[ "$file_or_folder" == *.xml ]]; then
          # echo "is xml. creating equivalent target txt"

          # since this xml file was detected by iterating over a folder (potentially recursively), 
          # an equivalent output folder / file structure must be created dynamically. 
          in_xml_path_single=$file_or_folder

          # remove /veld/input/* so that only relevant subfolder stays
          out_txt_path_single=${in_xml_path_single#$in_xml_path}

          # replace .xml with .txt
          out_txt_path_single=${out_txt_path_single/.xml/.txt}

          # concatenate main output folder passed via environment with dynamically created subpath
          out_txt_path_single="${out_txt_path}${out_txt_path_single}"

          # step further down, to reuse the xsltproc creation logic at the beginning of this
          # function
          do_xslt_recursively "$1" "$in_xml_path_single" "$out_txt_path_single"
        # else

          # is file, but not xml. Ignore then.
          # echo "is neither folder, nor xml"
        fi 

      # if folder
      elif [ -d "$file_or_folder" ]; then
        # echo "is folder"

        # recurse downwards into this subfolder
        do_xslt_recursively "$1" "$file_or_folder"
      fi
    done
  else

    # if parameter is a non-existing path
    echo "parameter is neither file, nor path. Exiting."
    exit 1
  fi
}

do_xslt_recursively "$in_xsl_path" "$in_xml_path" "$out_txt_path"
