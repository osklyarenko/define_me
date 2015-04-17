README
====
To launch execute
	rspec  environment_spec.rb --color

This silly DSL demonstrates that L-language is more or less irrelevant for DSLs. You can do all sorts of tricks with your language of choice. Your DSL should reflect your D-domain as accurately as possible.
---

Environment
* Mac OS X 10.9
* Ruby 1.9.3

Introduced concepts
* Definitions
* Facts

Definitions
---
Definitions describe an entity under test. Definitions can have the 'is_a' relationship with one another.

Facts
---
Facts describe assertions about the entity. Current implementation provides a straightforward 'is' assertion.

