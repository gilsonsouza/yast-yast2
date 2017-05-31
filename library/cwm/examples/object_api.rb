# Simple example to demonstrate object API for CWM

require_relative "example_helper"

require "cwm/widget"

Yast.import "CWM"
Yast.import "Wizard"

class LuckyNumberWidget < CWM::IntField
  attr_reader :result, :minimum, :maximum

  def initialize
    @minimum = 0
    @maximum = 1000
  end

  def label
    _("Lucky number")
  end

  def store
    @result = value
  end
end

class GenerateButton < CWM::PushButton
  def initialize(lucky_number_widget)
    @lucky_number_widget = lucky_number_widget
  end

  def label
    _("Generate Lucky Number")
  end

  def handle
    Yast::Builtins.y2milestone("handle called")
    @lucky_number_widget.value = rand(1000)

    nil
  end
end

module Yast
  class ExampleDialog
    include Yast::I18n
    include Yast::UIShortcuts
    def run
      textdomain "example"

      lucky_number_widget = LuckyNumberWidget.new
      button_widget = GenerateButton.new(lucky_number_widget)

      contents = HBox(
        button_widget,
        lucky_number_widget
      )

      Yast::Wizard.CreateDialog
      CWM.show(contents, caption: _("Lucky number"))
      Yast::Wizard.CloseDialog

      lucky_number_widget.result
    end
  end
end

Yast::ExampleDialog.new.run