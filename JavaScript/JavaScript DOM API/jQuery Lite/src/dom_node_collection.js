class DOMNodeCollection {
  constructor(elementArray) {
    this.elementArray = elementArray;
  }

  html(string = null) {
    if (string === null) {
      return this.elementArray[0].innerHTML;
    } else {
      this.elementArray.forEach(element => {
        element.innerHTML = string;
      })
    }
  }

  empty() {
    this.elementArray.forEach(element => {
      element.innerHTML = "";
    })
  }

  append(child) {
    if (child instanceof HTMLElement) {
     this.elementArray.forEach(element => {
       element.innerHTML = element.innerHTML + child.outerHTML;
      });
    } else if (typeof child === "string") {
      this.elementArray.forEach(element => {
        element.innerHTML = element.innerHTML + child;
      });
    } else if (typeof child.elementArray[Symbol.iterator] === "function") {
      this.elementArray.forEach(element => {
        child.elementArray.forEach(childElement => {
          element.innerHTML = element.innerHTML + childElement.outerHTML;
        });
      })
    }
  }

  attr(attribute, value = null) {
    if (value === null) {
      return this.elementArray[0].getAttribute(attribute);
    } else {
      this.elementArray.forEach(element => {
        element.setAttribute(attribute, value);
      })
    }
  }

  addClass(className) {
    this.elementArray.forEach(element => {
      element.classList.add(className);
    })
  }

  removeClass(className) {
    this.elementArray.forEach(element => {
      element.classList.remove(className);
    })
  }
}

module.exports = DOMNodeCollection;