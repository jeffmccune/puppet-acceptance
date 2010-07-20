notice("top scope of one.pp")
class issue4270::one {
  notify { "in base class issue4270::one": }
  notice("issue4270::one")
}
