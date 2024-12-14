#!/bin/bash

createNote() {
  # create temporary file
  note_file=$(mktemp "/tmp/notes-XXXXX.md")

  # start editor
  echo "editing $note_file"
  $NOTES_EDITOR $note_file
  
  # after editing
  if [[ -s $note_file ]]; then
    # retrieve the page
    title=$(head -n 1 ${note_file})
    page="${title//#/}"
    page="${page// /}"
    echo "page: $page"
    # create or update page file
    page_file="$NOTES_HOME/$page.md"
    if [[ ! -e $page_file ]]; then
      echo "creating new page file"
      touch $page_file
      echo -e "# $page\n" >> $page_file
    fi
    # create section for current date
    date=$(date -I)
    echo -e "## $date\n" >> $page_file
    # append new note under section
    cat $note_file | grep -v -x "$title" >> $page_file
  else
    echo "ignoring empty note"
  fi
}

listNotes() {
  if [[ -n "$1" ]]; then
    for i in $NOTES_HOME/$1*; do
      fileName=${i##*/}
      echo "- ${fileName%.md}"
    done
  else
    for i in $NOTES_HOME/*; do
      fileName=${i##*/}
      echo "- ${fileName%.md}"
    done
  fi
}

searchNote() {
  hits=( `grep -l -r $1 $NOTES_HOME/*.md` )
  for i in $hits; do
    fileName=${i##*/}
    echo "${fileName%.md}"
  done
}

if [[ -z "$1" ]]; then
  createNote
elif [[ "$1" == "search" ]]; then
  searchNote $2
elif [[ "$1" == "list" ]]; then
  listNotes $2
fi

