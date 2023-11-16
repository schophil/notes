#!/bin/bash

if [[ -z "$1" ]]; then
  note_name="tmp"
else
  note_name=$1
fi

createNote() {
  note_file="$NOTES_HOME/$note_name.md"
  if [[ -e $note_file ]]; then
    $EDITOR $note_file
  else
    # creating new note
    $EDITOR $note_file
  fi
}

listNotes() {
  if [[ -n "$1" ]]; then
    for i in $NOTES_HOME/$1*; do
      fileName=${i##*/}
      echo "${fileName%.md}"
    done
  else
    for i in $NOTES_HOME/*; do
      fileName=${i##*/}
      echo "${fileName%.md}"
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

if [[ "$note_name" == "sync" ]]; then
  syncNotes
elif [[ "$note_name" == "search" ]]; then
  searchNote $2
elif [[ "$note_name" == "list" ]]; then
  listNotes $2
else
  createNote
fi

