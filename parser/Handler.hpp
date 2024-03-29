#pragma once
#ifndef HANDLER_HPP
#define HANDLER_HPP

#include "lexer/Token.hpp"
#include "vm/IExecElems.hpp"
#include "parser/Pattern.hpp"

#include <deque>

namespace parser {

class Handler {
 protected:
  using iterator = std::deque<lexer::Token>::const_iterator;
  std::size_t m_token_processed = 0;

 private:
  virtual const pattern::Pattern& get_pattern(const lexer::Token&) const = 0;
  virtual void do_check(iterator i, iterator end) = 0;

 public:
  Handler() = default;
  Handler(const Handler&) = default;
  Handler& operator=(const Handler&) = default;
  virtual ~Handler() = default;
  void check(iterator i, iterator end);
  virtual std::unique_ptr<const exec::IExecElem> parse(iterator, iterator) const = 0;

  std::size_t token_processed() const;

  static Handler* get_handler(const lexer::Token& token);
};

}  // namespace parser
#endif  // HANDLER_HPP
