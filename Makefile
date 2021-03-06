# Makefile for ECOS
# Configuration of make process in ecos.mk
# ECOS JNILib
PACKAGE=com.github.ecos
PACKAGE_PATH=$(subst .,/,$(PACKAGE))

SRC=src/main
SRC_JAVA=$(SRC)/java
SRC_C=ecos/src
INCLUDE=ecos/include
RESOURCES=$(SRC)/main/resources

TARGET_C=target/
LIB_PATH=$(RESOURCES)/lib

GENERATED_HEADERS=${SRC}/native/com_github_ecos_NativeECOS.h
#ant javah generates the NativeECOS header, implement the NativeECOS.c driver
GENERATED_SOURCES=${SRC}/native/NativeECOS.c

include ecos/ecos.mk

#jni headers supported for Darwin(MacOSX) and Linux
UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
# we're on apple
C = $(CC) $(CFLAGS) -I/System/Library/Frameworks/JavaVM.framework/Headers -Iecos/include -I./external/ldl/include -Iecos/external/amd/include -I./external/SuiteSparse_config $(LDFLAGS)
JNIPATH=src/main/resources/lib/static/Mac\ OS\ X/x86_64
endif
ifeq ($(UNAME),Linux)
# we're on linux
C = $(CC) $(CFLAGS) -I/opt/bda/jdk/include -I/opt/bda/jdk/include/linux -Iecos/include -I./external/ldl/include -Iecos/external/amd/include -I./external/SuiteSparse_config $(LDFLAGS)
JNIPATH=src/main/resources/lib/static/Linux/amd64
endif

TEST_INCLUDES = -Itest -Itest/quadratic

# Compile all C code, including the C-callable routine
all: ldl amd ecos demo

# build Tim Davis' sparse LDL package
ldl:
	( cd external/ldl    ; $(MAKE) )	

# build Tim Davis' AMD package
amd:
	( cd external/amd    ; $(MAKE) )

AMD = amd_aat amd_1 amd_2 amd_dump amd_postorder amd_post_tree amd_defaults \
	amd_order amd_control amd_info amd_valid amd_preprocess

AMDL = $(addsuffix .o, $(subst amd_,amd_l_,$(AMD)))	
# build ECOS, make it OS indepedent
ecos: jniecos.o ecos.o kkt.o cone.o spla.o timer.o preproc.o splamm.o ctrlc.o equil.o expcone.o wright_omega.o
	$(C) -shared -o libecos.so jniecos.o ecos.o kkt.o cone.o spla.o timer.o preproc.o splamm.o ctrlc.o equil.o expcone.o wright_omega.o \
	external/ldl/ldl.o external/amd/amd_global.o external/amd/amd_l_1.o \
	external/amd/amd_l_2.o external/amd/amd_l_aat.o external/amd/amd_l_control.o external/amd/amd_l_defaults.o external/amd/amd_l_dump.o external/amd/amd_l_info.o \
	external/amd/amd_l_order.o external/amd/amd_l_post_tree.o external/amd/amd_l_postorder.o external/amd/amd_l_preprocess.o external/amd/amd_l_valid.o
	cp libecos.so $(JNIPATH)/libecos.jnilib
jniecos.o: ${GENERATED_SOURCES} ${GENERATED_HEADERS}
	$(C) -fPIC -c ${GENERATED_SOURCES} -o jniecos.o

ecos.o: ${SRC_C}/ecos.c ${INCLUDE}/ecos.h ${INCLUDE}/glblopts.h ${INCLUDE}/cone.h
	$(C) -fPIC -c ${SRC_C}/ecos.c -o ecos.o

kkt.o: ${SRC_C}/kkt.c ${INCLUDE}/kkt.h ${INCLUDE}/glblopts.h ${INCLUDE}/cone.h ${INCLUDE}/ecos.h
	$(C) -fPIC -c ${SRC_C}/kkt.c -o kkt.o

cone.o: ${SRC_C}/cone.c ${INCLUDE}/cone.h ${INCLUDE}/glblopts.h ${INCLUDE}/ecos.h
	$(C) -fPIC -c ${SRC_C}/cone.c -o cone.o

preproc.o: ${SRC_C}/preproc.c ${INCLUDE}/glblopts.h ${INCLUDE}/cone.h ${INCLUDE}/ecos.h
	$(C) -fPIC -c ${SRC_C}/preproc.c -o preproc.o

spla.o: ${SRC_C}/spla.c ${INCLUDE}/spla.h ${INCLUDE}/glblopts.h ${INCLUDE}/cone.h ${INCLUDE}/ecos.h
	$(C) -fPIC -c ${SRC_C}/spla.c -o spla.o

splamm.o: ${SRC_C}/splamm.c ${INCLUDE}/splamm.h ${INCLUDE}/glblopts.h ${INCLUDE}/cone.h ${INCLUDE}/ecos.h
	$(C) -fPIC -c ${SRC_C}/splamm.c -o splamm.o

ctrlc.o: ${SRC_C}/ctrlc.c ${INCLUDE}/ctrlc.h ${INCLUDE}/glblopts.h ${INCLUDE}/cone.h ${INCLUDE}/ecos.h
	$(C) -fPIC -c ${SRC_C}/ctrlc.c -o ctrlc.o

timer.o: ${SRC_C}/timer.c ${INCLUDE}/timer.h ${INCLUDE}/glblopts.h ${INCLUDE}/cone.h ${INCLUDE}/ecos.h
	$(C) -fPIC -c ${SRC_C}/timer.c -o timer.o

equil.o: ${SRC_C}/equil.c ${INCLUDE}/equil.h ${INCLUDE}/glblopts.h ${INCLUDE}/cone.h ${INCLUDE}/ecos.h
	$(C) -fPIC -c ${SRC_C}/equil.c -o equil.o

expcone.o: ${SRC_C}/expcone.c ${INCLUDE}/expcone.h
	$(C) -fPIC -c ${SRC_C}/expcone.c -o expcone.o

wright_omega.o: ${SRC_C}/wright_omega.c ${INCLUDE}/wright_omega.h
	$(C) -fPIC -c ${SRC_C}/wright_omega.c -o wright_omega.o

# ECOS demo
demo: ldl amd ecos ${SRC_C}/runecos.c 
	$(C) -L. -L./external/amd -L./external/ldl -o runecos ${SRC_C}/runecos.c -lecos -lamd -ldl $(LIBS)
	echo ECOS successfully built. Type ./runecos to run demo problem.

# ECOS tester
TEST_OBJS = qcml_utils.o norm.o sq_norm.o sum_sq.o quad_over_lin.o inv_pos.o sqrt.o
test: ldl amd ecos test/ecostester.c $(TEST_OBJS)
	$(C) $(TEST_INCLUDES) -o ecostester test/ecostester.c libecos.a $(LIBS) $(TEST_OBJS)

qcml_utils.o: test/generated_tests/qcml_utils.c test/generated_tests/qcml_utils.h
	$(C) $(TEST_INCLUDES) -c test/generated_tests/qcml_utils.c -o $@

norm.o: test/generated_tests/norm/norm.c test/generated_tests/norm/norm.h
	$(C) $(TEST_INCLUDES) -c test/generated_tests/norm/norm.c -o $@

quad_over_lin.o: test/generated_tests/quad_over_lin/quad_over_lin.c test/generated_tests/quad_over_lin/quad_over_lin.h
	$(C) $(TEST_INCLUDES) -c test/generated_tests/quad_over_lin/quad_over_lin.c -o $@

sq_norm.o: test/generated_tests/sq_norm/sq_norm.c test/generated_tests/sq_norm/sq_norm.h
	$(C) $(TEST_INCLUDES) -c test/generated_tests/sq_norm/sq_norm.c -o $@

sum_sq.o: test/generated_tests/sum_sq/sum_sq.c test/generated_tests/sum_sq/sum_sq.h
	$(C) $(TEST_INCLUDES) -c test/generated_tests/sum_sq/sum_sq.c -o $@

inv_pos.o: test/generated_tests/inv_pos/inv_pos.c test/generated_tests/inv_pos/inv_pos.h
	$(C) $(TEST_INCLUDES) -c test/generated_tests/inv_pos/inv_pos.c -o $@

sqrt.o: test/generated_tests/sqrt/sqrt.c test/generated_tests/sqrt/sqrt.h
	$(C) $(TEST_INCLUDES) -c test/generated_tests/sqrt/sqrt.c -o $@

# remove object files, but keep the compiled programs and library archives
clean:
	( cd external/ldl    ; $(MAKE) clean )
	( cd external/amd    ; $(MAKE) clean )
	- $(RM) $(CLEAN)

# clean, and then remove compiled programs and library archives
purge: clean
	( cd external/ldl    ; $(MAKE) purge )
	( cd external/amd    ; $(MAKE) purge )	
	- $(RM) libecos.so $(JNIPATH)/libecos.jnilib runecos
