notice("top scope of two.pp")
class issue4270::two inherits issue4270::one {
  notify { "in child class issue4270::two": }
  notice("issue4270::two")
}
