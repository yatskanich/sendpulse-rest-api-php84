<?php

namespace Sendpulse\RestApi;

use Exception;
use Throwable;

class ApiClientException extends Exception
{
    public function __construct(
        string $message = "",
        int $code = 0,
        ?Throwable $previous = null,
        public ?array $response = null {
            get {
                if ($this->response === null) {
                    $this->response = [];
                }
                return $this->response;
            }
        },
        private readonly ?string $headers = null,
        private readonly ?string $curlErrors = null
    ) {
        if ($this->response === null) {
            $this->response = [];
        }
        parent::__construct($message, $code, $previous);
    }

    /**
     * @return string|null
     */
    public function getHeaders(): ?string
    {
        return $this->headers;
    }

    /**
     * @return string|null
     */
    public function getCurlErrors(): ?string
    {
        return $this->curlErrors;
    }

}
