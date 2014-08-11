#!/bin/bash

pushd .

TARGET_DIR=../ftsrg.github.io/mdsd/2014/

cp eclipse_basics.pdf $TARGET_DIR

cp code_generation.pdf $TARGET_DIR
cp emf.pdf $TARGET_DIR
cp incquery.pdf $TARGET_DIR
cp yakindu.pdf $TARGET_DIR

cp bonita_connector.pdf $TARGET_DIR
cp bpmn.pdf $TARGET_DIR
cp cassandra.pdf $TARGET_DIR
cp nosql.pdf $TARGET_DIR
cp web_services.pdf $TARGET_DIR

cd $TARGET_DIR
git add *.pdf
git commit -m "Releasing notes."
git push

popd
