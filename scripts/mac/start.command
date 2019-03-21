#!/bin/bash

DIR=`dirname $0`

cd $DIR/../..
vagrant box update --force
vagrant up
