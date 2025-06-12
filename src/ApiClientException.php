<?php

namespace Sendpulse\RestApi;

use Exception;
use Throwable;

class ApiClientException extends Exception
{
    /**
     * @param string $message
     * @param int $code
     * @param Throwable|null $previous
     * @param array $response
     * @param string|null $headers
     * @param string|null $curlErrors
     */
    public function __construct(
        string    $message = "",
        int       $code = 0,
        ?Throwable $previous = null,
        private readonly array $response = [],
        private readonly ?string $headers = null,
        private readonly ?string $curlErrors = null
    )
    {
        parent::__construct($message, $code, $previous);
    }

    /**
     * @return array
     */
    public function getResponse(): array
    {
        return $this->response;
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
