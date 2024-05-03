from textual.app import App, ComposeResult
from textual.events import Key
from textual.widgets import Button, Header, Label


class MainScreen(App[str]):
    CSS_PATH = "main_screen.tcss"
    TITLE = "Main Screen"
    SUB_TITLE = "Choose an Option"

    def compose(self) -> ComposeResult:
        yield Header()
        yield Label("Welcome! Please choose an option:", id="question")
        yield Button("Option 1", id="option_1", variant="primary")
        yield Button("Option 2", id="option_2", variant="primary")
        yield Button("Option 3", id="option_3", variant="primary")
        yield Button("Option 4", id="option_4", variant="primary")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        option = event.button.id
        if option == "option_1":
            self.select_option_1()
        elif option == "option_2":
            self.select_option_2()
        elif option == "option_3":
            self.select_option_3()
        elif option == "option_4":
            self.select_option_4()

    def select_option_1(self):
        # Code to handle option 1 selected
        print("Option 1 selected!")
        self.exit("Option 1")

    def select_option_2(self):
        # Code to handle option 2 selected
        print("Option 2 selected!")
        self.exit("Option 2")

    def select_option_3(self):
        # Code to handle option 3 selected
        print("Option 3 selected!")
        self.exit("Option 3")

    def select_option_4(self):
        # Code to handle option 4 selected
        print("Option 4 selected!")
        self.exit("Option 4")


if __name__ == "__main__":
    app = MainScreen()
    reply = app.run()
    print(reply)
