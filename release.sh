#!/bin/bash
cp eclipse_basics.pdf ../../public/2014
cp bpmn.pdf ../../public/2014
cp emf.pdf ../../public/2014
cp cassandra.pdf ../../public/2014
cp yakindu.pdf ../../public/2014
cp web_services.pdf ../../public/2014
cp bonita_connector.pdf ../../public/2014
cp code_generation.pdf ../../public/2014
cp nosql.pdf ../../public/2014
cp incquery.pdf ../../public/2014
cp rest_service_docs.pdf ../../public/2014
cd ../../public/2014
svn add *.pdf
svn commit -m "releasing notes"
