
ns respo-spa-devtools.component.element $ :require
  [] hsl.core :refer $ [] hsl
  [] respo.alias :refer $ [] create-comp div span Component

defn style-element (focused?)
  {} (:display |flex)
    :align-items |flex-start
    :box-shadow $ str "|0 -1px 0 "
      hsl 0 0 90
    :background-color $ if focused?
      hsl 200 80 40 0.5
      , |transparent
    :transition-duration |200ms

def style-info $ {} (:display |flex)
  :flex-direction |column

def style-component $ {}
  :background-color $ hsl 240 50 50 0.5
  :color $ hsl 0 0 100
  :padding "|0 4px"
  :font-family |Menlo

def style-name $ {} (:font-family |Menlo)
  :display |inline-block
  :background-color $ hsl 140 80 70 0.5
  :color $ hsl 0 0 100
  :padding "|0 4px"
  :height |auto
  :cursor |pointer

def style-space $ {} (:width |8px)

def style-children $ {}

defn handle-click (props state)
  fn (simple-event dispatch mutate)
    let
      (devtools-state $ :state props)
        element $ :element props
        store $ :store devtools-state
        mount-point $ :mount-point props
        coord $ :coord element
        selector $ str "|[data-coord=\"" (pr-str coord)
          , "|\"]"
        target $ -> js/document (.querySelector mount-point)
          .querySelector selector
        rect $ .getBoundingClientRect target

      .log js/console selector $ js->clj rect
      dispatch :state $ {}
        :focus $ :coord element
        :rect rect

def element-component $ create-comp :element
  fn (props)
    {}
  , merge
  fn (props)
    fn (state)
      let
        (devtools-state $ :state props)
          element $ :element props
          store $ :store props
        div
          {} $ :style
            style-element $ = (:coord element)
              :focused props

          div ({} :style style-info)
            if
              = Component $ type element
              span $ {} (:style style-component)
                :attrs $ {} :inner-text
                  name $ :name element

              span $ {} (:style style-name)
                :attrs $ {} :inner-text
                  name $ :name element
                :event $ {} :click (handle-click props state)

          div $ {} (:style style-space)
          if
            = Component $ type element
            div ({} :style style-children)
              element-component $ {}
                :element $ :tree element
                :focused $ :focused props
                :mount-point $ :mount-point props

            div
              {} $ :style style-children
              ->> (:children element)
                map $ fn (entry)
                  [] (key entry)
                    element-component $ {}
                      :element $ val entry
                      :focused $ :focused props
                      :mount-point $ :mount-point props

                into $ sorted-map
