import { BridgeElement } from "@hotwired/hotwire-native-bridge"

BridgeElement.prototype.getButton = function() {
  const button = {
    title: this.title,
    icon: this.getIcon(),
    displayTitle: this.getDisplayTitle(),
    isMainAction: this.getIsMainAction()
  }
  console.log(button)
  return button
}

BridgeElement.prototype.getIcon = function() {
  const url = this.bridgeAttribute(`icon-url`)

  if (url) {
    return { url }
  }

  return null
}

BridgeElement.prototype.getDisplayTitle = function() {
  return !!this.bridgeAttribute(`display-title`)
}

BridgeElement.prototype.getIsMainAction = function() {
  return !!this.bridgeAttribute(`main-action`)
}
