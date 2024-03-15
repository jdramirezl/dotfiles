import requests

from typing import Tuple


class Request:
    @staticmethod
    def _make_request(
        url: str, method: str, payload: dict, headers: dict
    ) -> Tuple[dict, int]:
        try:
            response = requests.request(method, url, headers=headers, data=payload)
        except requests.exceptions.RequestException as e:
            print(f"Error making request: {e}")
            raise e

        return response.json(), response.status_code

    @staticmethod
    def get(url: str, payload: dict, headers: dict) -> Tuple[dict, int]:
        response, status = Request._make_request(url, "GET", payload, headers)

        if status != 200:
            print(f"Error: {response}")
            raise Exception(f"Error: {response}")

        return response, status

    @staticmethod
    def post(url: str, payload: dict, headers: dict) -> Tuple[dict, int]:
        response, status = Request._make_request(url, "POST", payload, headers)

        if status != 201:
            print(f"Error: {response}")
            raise Exception(f"Error: {response}")

        return response, status
