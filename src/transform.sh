#!/bin/bash

if [[ "$in_xml_url" != "" ]]; then
  if [[ "$in_xml_path" != "" ]]; then
    echo "both in_xml_url and in_xml_path are provided. Exiting. Define only one." 
    exit 1
  fi
  echo "downloading xml from ${in_xml_url}"
  curl -o /tmp/tmp.xml "$in_xml_url"
  in_xml_path=/tmp/tmp.xml
fi

if [[ "$in_xsl_url" != "" ]]; then
  if [[ "$in_xsl_path" != "" ]]; then
    echo "both in_xsl_url and in_xsl_path are provided. Exiting. Define only one." 
    exit 1
  fi
  echo "downloading xsl from ${in_xsl_url}"
  curl -o /tmp/tmp.xsl "$in_xsl_url"
  in_xsl_path=/tmp/tmp.xsl
fi

do_xslt_recursively() {
  echo "do_xslt_recursively" "$1" "$2" "$3"
  if [ -f "$2" ]; then
    if [[ "$2" == *.xml ]]; then
      echo "is xml. processing"
      out_txt_path_folder=${3%/*}
      if ! [ -e "$out_txt_path_folder" ]; then
        mkdir -p "$out_txt_path_folder"
      fi
      echo "executing xsltproc ${1} ${2} > ${3}"
      xsltproc "$1" "$2" > "$3"
    else
      echo "not a xml file" "$2"
      exit 1
    fi
  elif [ -d "$2" ]; then
    echo "check content of folder" "$2"
    for file_or_folder in "$2"/*; do
      echo "check if file or folder" "$file_or_folder"
      if [ -f "$file_or_folder" ]; then
        if [[ "$file_or_folder" == *.xml ]]; then
          echo "is xml. creating equivalent target txt"
          in_xml_path_single=$file_or_folder
          out_txt_path_single=${in_xml_path_single/\/veld\/input\/1\//}
          out_txt_path_single=${out_txt_path_single/.xml/.txt}
          out_txt_path_single="${out_txt_path}${out_txt_path_single}"
          do_xslt_recursively "$1" "$in_xml_path_single" "$out_txt_path_single"
        else
          echo "is neither folder, nor xml"
        fi 
      elif [ -d "$file_or_folder" ]; then
        echo "is folder"
        do_xslt_recursively "$1" "$file_or_folder"
      fi
    done
  else
    echo "parameter is neither file, nor path. Exiting."
    exit 1
  fi
}

do_xslt_recursively $in_xsl_path $in_xml_path $out_txt_path
