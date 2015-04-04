echo copying files
copy eclipse_basics.pdf ..\..\public\2014
copy bpmn.pdf ..\..\public\2014
copy emf.pdf ..\..\public\2014
copy web_services.pdf ..\..\public\2014
copy yakindu.pdf ..\..\public\2014
copy bonita_connector.pdf ..\..\public\2014
copy code_generation.pdf ..\..\public\2014
copy nosql.pdf ..\..\public\2014
copy incquery.pdf ..\..\public\2014
cd ..\..\public\2014
svn add *.pdf
svn commit -m "releasing notes"
