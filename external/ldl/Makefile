#-------------------------------------------------------------------------------
# Makefile for the LDL library
#-------------------------------------------------------------------------------

default: all

ECOS = ../../ecos
LDLSRC = $(ECOS)/external/ldl
SUITESPARSESRC=$(ECOS)/external/SuiteSparse_config

include $(ECOS)/ecos.mk

INCLUDES = -I$(SUITESPARSESRC) -I$(LDLSRC)/include

C = $(CC) $(CFLAGS) $(INCLUDES)

all: libldl.so

#-------------------------------------------------------------------------------
# the ldl library:
#-------------------------------------------------------------------------------

libldl.so: $(LDLSRC)/src/ldl.c $(LDLSRC)/include/ldl.h
	$(C) -fPIC -DLDL_LONG -c $(LDLSRC)/src/ldl.c -o ldl.o
	$(C) -shared -o libldl.so ldl.o

purge: 
	- $(RM) libldl.so
clean:
	- $(RM) $(CLEAN)


