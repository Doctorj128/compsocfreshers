CC = java -jar ../../Programs/KickAssembler/KickAss.jar
CCFLAGS = -replacefile sids/compsocmusic.sid 
TARGETS = compsoc-atw compsoc-axel compsoc-cyb compsoc-cyb2 compsoc-ln2 compsoc-motr compsoc-awm compsoc-star compsoc-light compsoc-cc compsoc-sanx

all:	${TARGETS}

compsoc-atw:
	${CC} compsocdemo-reduced.asm -o out/compsoc-atw ${CCFLAGS} sids/aroundtheworld.sid

compsoc-axel:
	${CC} compsocdemo-reduced.asm -o out/compsoc-axel ${CCFLAGS} sids/axelf.sid

compsoc-cyb:
	${CC} compsocdemo-reduced.asm -o out/compsoc-cyb ${CCFLAGS} sids/cybernoid.sid

compsoc-cyb2:
	${CC} compsocdemo-reduced.asm -o out/compsoc-cyb2 ${CCFLAGS} sids/cybernoid2.sid

compsoc-ln2:
	${CC} compsocdemo-reduced.asm -o out/compsoc-ln2 ${CCFLAGS} sids/lastninja2centralpark.sid

compsoc-motr:
	${CC} compsocdemo-reduced.asm -o out/compsoc-motr ${CCFLAGS} sids/montyontherun.sid

compsoc-awm:
	${CC} compsocdemo-reduced.asm -o out/compsoc-awm ${CCFLAGS} sids/aufwiedersehenmonty.sid

compsoc-star:
	${CC} compsocdemo-reduced.asm -o out/compsoc-star ${CCFLAGS} sids/starforce.sid

compsoc-light:
	${CC} compsocdemo-reduced.asm -o out/compsoc-light ${CCFLAGS} sids/lightforce.sid

compsoc-cc:
	${CC} compsocdemo-reduced.asm -o out/compsoc-cc ${CCFLAGS} sids/crazycomets.sid

compsoc-sanx:
	${CC} compsocdemo-reduced.asm -o out/compsoc-sanx ${CCFLAGS} sids/sanxion.sid

clean:
	rm -f out/* *.prg *.sym
