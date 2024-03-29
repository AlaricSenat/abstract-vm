# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asenat <marvin@42.fr>                      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/10/22 10:52:15 by asenat            #+#    #+#              #
#    Updated: 2018/12/17 17:02:20 by asenat           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

## Standard things
#
.SUFFIXES:
NAME		:= abstract-vm
CC 		:= clang++
CFLAGS		:= -I. -Wall -Wextra -Werror -std='c++14' -O2
RM		:= rm -f
OBJECT_DIR	:= obj
COMP		:= $(CC) $(CFLAGS) -c -o
ifeq ($(shell uname -s), Darwin)
ECHO		:= echo
else
ECHO		:= echo -e
endif
#

## Sources directories
#
TEST_DIRS	:= tests
SRC_DIRS	:= vm lexer parser utils
#

## Colors
#
BLUE		:= "\033[34m"
GREEN		:= "\033[32m"
RED		:= "\033[31m"
RESET		:= "\033[0m"
PNAME		:= $(BLUE)$(NAME)$(RESET)
#

.PHONY: all
all: $(NAME)

## Including sources files
#
include $(patsubst %, %/Sources.mk, $(SRC_DIRS))
#

OBJ_DIRS	:= $(patsubst %, %/obj, $(SRC_DIRS))

$(NAME): $(OBJ_DIRS) $(OBJECTS) $(IMPL_OBJS)
	$(CC) $(LFLAGS) -o $(NAME) $(OBJECTS) $(IMPL_OBJS)
	strip -x $(NAME)
	@$(ECHO) $(PNAME)$(GREEN) "linking complete"$(RESET)

## Including compilation rules
#
include $(patsubst %, %/Rules.mk, $(SRC_DIRS))
#

%/$(OBJECT_DIR):
	mkdir $@

## Including tests
#
-include $(patsubst %, %/Rules.mk, $(TEST_DIRS))
#

.PHONY: clean
clean:
	@$(RM) -r $(OBJ_DIRS)
	@$(ECHO) "Objects directories removed"

.PHONY: fclean
fclean: clean
	@$(RM) $(NAME) $(TEST_TARGETS)
	@$(ECHO) $(NAME) "deleted"

.PHONY: re
re: fclean all

.PHONY: makedeps
makedeps:
	python3.6 ./gen_make_sources.py --source='.cpp' $(SRC_DIRS)
