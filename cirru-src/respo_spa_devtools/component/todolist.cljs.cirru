
ns respo-spa-devtools.component.todolist $ :require
  [] hsl.core :refer $ [] hsl
  respo-spa-devtools.component.task :refer $ [] task-component

def style-todolist $ {} (:font-family |Verdana)
  :width |400px
  :box-shadow $ str "|0 0 1px "
    hsl 0 0 0 0.3
  :background-color $ hsl 200 70 94

def style-header $ {} (:width |100%)
  :display |flex
  :padding |4px

def style-input $ {} (:line-height |32px)
  :font-size |16px
  :border |none
  :outline |none
  :flex |1

def style-add $ {}
  :background-color $ hsl 200 80 80
  :color |white
  :padding "|0 16px"
  :line-height |32px
  :display |inline-block
  :cursor |pointer

defn handle-change (props state)
  fn (simple-event dispatch mutate)
    mutate $ {}
      :draft $ :value simple-event

defn handle-add (store state)
  fn (simple-event dispatch mutate)
    dispatch :add $ :draft state
    mutate $ {} (:draft |)

def todolist-component $ {} (:name :todolist)
  :update-state merge
  :get-state $ fn (store)
    {} $ :draft |
  :render $ fn (store)
    fn (state)
      let
        (tasks store)
        [] :div ({} :style style-todolist)
          [] :div
            {} $ :style style-header
            [] :input $ {}
              :value $ :draft state
              :on-input $ handle-change store state
              :placeholder "|new task"
              :style style-input
            [] :span $ {} (:inner-text |Add)
              :on-click $ handle-add store state
              :style style-add

          [] :div ({})
            ->> tasks
              map $ fn (task)
                [] (:id task)
                  [] task-component task

              into $ sorted-map
