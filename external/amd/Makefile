#-------------------------------------------------------------------------------
# AMD Makefile for compiling on Unix systems (for GNU make only)
#-------------------------------------------------------------------------------

default: libamd.so

ECOS = ../../ecos
AMDSRC = $(ECOS)/external/amd
SUITESPARSESRC=$(ECOS)/external/SuiteSparse_config

include $(ECOS)/ecos.mk

C = $(CC) $(CFLAGS) -I$(AMDSRC)/include -I$(SUITESPARSESRC)

#-------------------------------------------------------------------------------
# source files
#-------------------------------------------------------------------------------

AMD = amd_aat amd_1 amd_2 amd_dump amd_postorder amd_post_tree amd_defaults \
	amd_order amd_control amd_info amd_valid amd_preprocess

CONFIG = $(SUITESPARSESRC)/SuiteSparse_config.h

INC = $(AMDSRC)/include/amd.h $(AMDSRC)/include/amd_internal.h $(CONFIG)

#-------------------------------------------------------------------------------
# object files for each long version
#-------------------------------------------------------------------------------

AMDL = $(addsuffix .o, $(subst amd_,amd_l_,$(AMD)))

#-------------------------------------------------------------------------------
# compile long routines for JVM (with no real/complex version)
#-------------------------------------------------------------------------------

amd_global.o: $(AMDSRC)/src/amd_global.c $(INC)
	$(C) -fPIC -c $< -o $@

amd_l_%.o: $(AMDSRC)/src/amd_%.c $(INC)
	$(C) -fPIC -DDLONG -c $< -o $@
#-------------------------------------------------------------------------------
# Create the libamd.a library (C versions only)
#-------------------------------------------------------------------------------

libamd.so: amd_global.o $(AMDI) $(AMDL)
	$(C) -shared -o libamd.so $^

#-------------------------------------------------------------------------------
# Remove all but the files in the original distribution
#-------------------------------------------------------------------------------

clean:
	- $(RM) $(CLEAN)

purge: 
	- $(RM) libamd.so libamdf77.so

