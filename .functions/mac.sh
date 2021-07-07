#!/bin/bash

function notification() {
  case $# in
    1)
      message=$1
      title="Notification";;
    2)
      message=$1
      title=$2;;
    *)
      return;;
  esac
  command /usr/bin/osascript -e "display notification \"$message\" with title \"$title\""
}
