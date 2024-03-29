#include "parser/Handler.hpp"
#include "parser/Errors.hpp"

#include <cassert>

namespace parser {

void Handler::check(iterator i, iterator end) {
  assert(i != end);
  const auto& pattern = get_pattern(*i);
  iterator begin = i;
  m_token_processed = 0;
  for (const auto* ptoken : pattern) {
    if (i == end) throw ParseError(ParseError::Err::UnexpectedEOF);
    try {
      do_check(i, end);
      if (m_token_processed) {
        i += m_token_processed;
        m_token_processed = 0;
        continue;
      }
    } catch (ParseError&) {
      throw;
    }
    if (ptoken->optional()) {
      if (*ptoken == *i) ++i;
    } else {
      if (*ptoken != *i) throw ParseError(ParseError::Err::UnexpectedToken, *i);
      ++i;
    }
  }
  m_token_processed = i - begin;
}

  std::size_t Handler::token_processed() const { return m_token_processed; }

}  // namespace parser
