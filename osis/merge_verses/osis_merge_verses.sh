#!/bin/sh

gawk '
BEGIN{sID=eID=txt=allIDs="";}
function emitverse(){
	if((sID!="")&&(sID==eID)){
		sV=gensub("^.+[.]([0-9]+)$","\\1",1,sID)
		print "\t\t\t<verse sID=\""sID"\" osisID=\""sID"\" n=\""sV"\"/>"txt"<verse eID=\""sID"\"/>"
	}else if((sID!="")&&(sID!=eID)){
		sV=gensub("^.+[.]([0-9]+)$","\\1",1,sID)
		eV=gensub("^.+[.]([0-9]+)$","\\1",1,eID)
		print "\t\t\t<verse sID=\""sID"-"eID"\" osisID=\""allIDs"\" n=\""sV"-"eV"\"/>"txt"<verse eID=\""sID"-"eID"\"/>"
	}
	sID=eID=txt=allIDs=""
}
$1~/<[?/a-zA-Z]+/{
	if($1=="<verse"){
		newtxt=$0
		sub("^[^>]+>","",newtxt)
		sub("<[^<]+$","",newtxt)
		split($0,a,"\"")
		newID=a[2]
		if(sID==""){
			sID=eID=allIDs=newID
			txt=newtxt
		}else if(txt==newtxt){
			eID=newID
			allIDs=allIDs" "newID
		}else{
			emitverse()
			sID=eID=allIDs=newID
			txt=newtxt
		}
	}else{
		emitverse()
		print $0
	}
}
END{emitverse()}
'
