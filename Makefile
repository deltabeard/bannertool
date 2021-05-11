NAME := bannertool

TARGET := $(NAME).elf
CFLAGS := -O2 -std=gnu11 -Wall
CXXFLAGS := -O2 -std=gnu++11
LDFLAGS := -lm
OBJEXT := o
CXX := c++

# Visual Studio is special.
ifdef VSCMD_VER
	TARGET := $(NAME).exe
	CC = cl
	OBJEXT := obj
	RM := del
	CFLAGS := /nologo /utf-8 /FS /MD /O1 /EHsc
	LDFLAGS := /link /SUBSYSTEM:CONSOLE
endif


SRCS := $(wildcard source/*.c*) $(wildcard source/3ds/*.c*) $(wildcard source/pc/*.c*)
OBJS := $(SRCS:.c=.$(OBJEXT))


VERSION_PARTS := $(subst ., ,$(shell git describe --tags --abbrev=0))
VERSION_MAJOR := $(word 1, $(VERSION_PARTS))
VERSION_MINOR := $(word 2, $(VERSION_PARTS))
VERSION_MICRO := $(word 3, $(VERSION_PARTS))

CPPFLAGS += -DVERSION_MAJOR=$(VERSION_MAJOR)
CPPFLAGS += -DVERSION_MINOR=$(VERSION_MINOR)
CPPFLAGS += -DVERSION_MICRO=$(VERSION_MICRO)

all: $(TARGET)

# Unix Rules
%.elf: $(OBJS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

# MSVC Rules
%.exe: $(OBJS)
	$(CC) $(CFLAGS) $(CPPFLAGS) /Fe$@ $^ $(LDFLAGS)

%.obj: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) /Fo$@ /c /TC $^

%.obj: %.cpp
	$(CC) $(CFLAGS) $(CPPFLAGS) /Fo$@ /c /TC $^

clean:
	$(RM) $(TARGET) $(OBJS)
