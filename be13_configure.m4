#
# mix-ins for be13
#

AC_MSG_NOTICE([Including be13_configure.m4 from be13_api])
AC_CHECK_HEADERS([err.h pwd.h sys/cdefs.h sys/mman.h sys/resource.h sys/utsname.h unistd.h ])
AC_CHECK_FUNCS([ishexnumber isxdigit unistd.h mmap err errx warn warnx pread64 pread strptime _lseeki64 utimes ])

AC_TRY_COMPILE([#pragma GCC diagnostic ignored "-Wredundant-decls"],[int a=3;],
  [AC_DEFINE(HAVE_DIAGNOSTIC_REDUNDANT_DECLS,1,[define 1 if GCC supports -Wredundant-decls])]
)
AC_TRY_COMPILE([#pragma GCC diagnostic ignored "-Wcast-align"],[int a=3;],
  [AC_DEFINE(HAVE_DIAGNOSTIC_CAST_ALIGN,1,[define 1 if GCC supports -Wcast-align])]
)

AC_TRY_LINK([#include <inttypes.h>],
               [uint64_t ul; __sync_add_and_fetch(&ul,0);],
               AC_DEFINE(HAVE___SYNC_ADD_AND_FETCH,1,[define 1 if __sync_add_and_fetch works on 64-bit numbers]))


#
# Figure out which version of unordered_map we are going to use
#
AC_LANG_PUSH(C++)
  SAVE_CXXFLAGS="$CXXFLAGS"
  CXX_FLAGS="$CXXFLAGS -std=c++11"
  AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[]], [[]])],
      [has_option=yes],
      [has_option=no])
  if test $has_option = "yes" ; then
    AC_MSG_RESULT([Has -std=c++11 support. Checking for unordered_map])
    AC_CHECK_HEADERS([unordered_map unordered_set])
  else
    AC_MSG_RESULT([No -std=c++11 support. Checking for legacy tr1 support])
    CXXFLAGS="$SAVE_CXXFLAGS"
    AC_CHECK_HEADERS([tr1/unordered_map tr1/unordered_set])
  fi
AC_LANG_POP()    

