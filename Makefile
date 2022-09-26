CC = java -jar ../../Programs/KickAssembler/KickAss.jar
CCFLAGS = -replacefile sids/compsocmusic.sid 
TARGETS = compsoc-atw compsoc-axel compsoc-cyb compsoc-cyb2 compsoc-ln2 compsoc-motr compsoc-star

all:	${TARGETS}

compsoc-atw:
	${CC} compsocdemo.asm -o out/compsoc-atw ${CCFLAGS} sids/aroundtheworld.sid

compsoc-axel:
	${CC} compsocdemo.asm -o out/compsoc-axel ${CCFLAGS} sids/axelf.sid

compsoc-cyb:
	${CC} compsocdemo.asm -o out/compsoc-cyb ${CCFLAGS} sids/cybernoid.sid

compsoc-cyb2:
	${CC} compsocdemo.asm -o out/compsoc-cyb2 ${CCFLAGS} sids/cybernoid2.sid

compsoc-ln2:
	${CC} compsocdemo.asm -o out/compsoc-ln2 ${CCFLAGS} sids/lastninja2centralpark.sid

compsoc-motr:
	${CC} compsocdemo.asm -o out/compsoc-motr ${CCFLAGS} sids/montyontherun.sid

compsoc-star:
	${CC} compsocdemo.asm -o out/compsoc-star ${CCFLAGS} sids/starforce.sid

clean:
	rm -f out/* *.prg *.sym
