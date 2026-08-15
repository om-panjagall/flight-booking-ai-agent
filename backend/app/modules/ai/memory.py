from typing import List


class ConversationMemory:

    def __init__(
        self,
        max_history: int = 6,
    ):

        self._history: List[
            dict[str, str]
        ] = []

        self.max_history = max_history

    def add_user_message(
        self,
        content: str,
    ) -> None:

        self._history.append(
            {
                "role": "user",
                "content": content,
            }
        )

        self._trim_history()

    def add_assistant_message(
        self,
        content: str,
    ) -> None:

        self._history.append(
            {
                "role": "assistant",
                "content": content,
            }
        )

        self._trim_history()

    def get_history(
        self,
    ) -> List[dict[str, str]]:

        return list(
            self._history
        )

    def _trim_history(
        self,
    ) -> None:

        if len(self._history) > self.max_history:

            self._history = (
                self._history[
                    -self.max_history:
                ]
            )