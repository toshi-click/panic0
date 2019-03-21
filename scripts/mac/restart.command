#!/bin/bash

DIR=`dirname $0`

cd $DIR/../..
vagrant halt
vagrant box update --force
vagrant up
