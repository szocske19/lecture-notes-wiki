del %1.pdf
pandoc %1.md --output=%1.pdf --table-of-contents --variable=geometry:margin=1in --variable=course:%2 --variable=title:%3 --variable=documentclass:report --template=template.latex --variable=author:"G\'abor Sz\'arnyas" --variable=author:"Oszk\'ar Semer\'ath" --variable=numbersections
