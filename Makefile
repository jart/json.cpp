CXXFLAGS = -std=c++11 -O

check:	json_test.ok			\
	jsontestsuite_test.ok

clean:
	rm -f *.o *.a *.ok *_test *.elf *.dbg
	rm -rf .aarch64

json.o: json.cpp json.h

fuzz.o: fuzz.cpp json.h
fuzz: fuzz.o json.o double-conversion.a

json_test.o: json_test.cpp json.h
json_test: json_test.o json.o double-conversion.a

jsontestsuite_test.o: jsontestsuite_test.cpp json.h
jsontestsuite_test: jsontestsuite_test.o json.o double-conversion.a

%: %.o
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $(OUTPUT_OPTION) $^

%.ok: %
	./$<
	touch $@

################################################################################
# double-conversion

double-conversion.a:			\
		bignum.o		\
		bignum-dtoa.o		\
		cached-powers.o		\
		double-to-string.o	\
		fast-dtoa.o		\
		fixed-dtoa.o		\
		string-to-double.o	\
		strtod.o
	$(AR) rcs $@ $^

%.o: double-conversion/%.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $<